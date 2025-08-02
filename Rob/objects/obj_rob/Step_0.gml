
// Se o robô colidiu, congela e espera o alarme reiniciar
if (is_collided) {
    exit;
}

// --- ATUALIZAR MÉTRICAS DA TENTATIVA ATUAL ---
time_elapsed += 1 / game_get_speed(gamespeed_fps);
distance_traveled += point_distance(x, y, prev_x, prev_y);
prev_x = x;
prev_y = y;

// --- 1. LER SENSORES E ENCONTRAR O OBSTÁCULO MAIS CRÍTICO ---
var dist_minima = -1;
var angulo_sensor_critico = 0;

for (var i = 0; i < array_length(angulos_sensores); i++) {
    var angulo_sensor_atual = direcao_movimento + angulos_sensores[i];
    var sensor_x_inicio = x + lengthdir_x(raio_robo, angulo_sensor_atual);
    var sensor_y_inicio = y + lengthdir_y(raio_robo, angulo_sensor_atual);
    var sensor_x_fim = sensor_x_inicio + lengthdir_x(distancia_sensor, angulo_sensor_atual);
    var sensor_y_fim = sensor_y_inicio + lengthdir_y(distancia_sensor, angulo_sensor_atual);
    var inst_colidida = collision_line(sensor_x_inicio, sensor_y_inicio, sensor_x_fim, sensor_y_fim, obj_obstaculo, false, true);
    leituras_sensores[i] = (inst_colidida != noone);
    if (leituras_sensores[i]) {
        var dist_atual = point_distance(x, y, inst_colidida.x, inst_colidida.y);
        distancias_sensores[i] = dist_atual;
        if (dist_minima == -1 || dist_atual < dist_minima) {
            dist_minima = dist_atual;
            angulo_sensor_critico = angulos_sensores[i];
        }
    } else {
        distancias_sensores[i] = -1;
    }
}

// --- 2. LÓGICA DE NAVEGAÇÃO HÍBRIDA ---
var angulo_de_viragem = 0;

// --- DETEÇÃO DE ESTAGNAÇÃO ---
stuck_check_timer++;
if (stuck_check_timer > room_speed / 2) {
    stuck_check_timer = 0;
    if (point_distance(x, y, stuck_check_pos_x, stuck_check_pos_y) < velocidade * 5) {
        estado = ESTADO.ESCAPANDO;
        estado_string = "Escapando";
        escape_timer = room_speed * 2; // Foge por 2 segundos
    }
    stuck_check_pos_x = x;
    stuck_check_pos_y = y;
}

// --- MÁQUINA DE ESTADOS ---
switch (estado) {
    case ESTADO.BUSCANDO:
        // --- LÓGICA NORMAL DO MIRAN ---
        if (dist_minima != -1) {
            var angulo_escape = darctan((raio_robo + margem_seguranca) / dist_minima);
            angulo_de_viragem = (angulo_sensor_critico >= 0) ? -angulo_escape : angulo_escape;
            angulo_de_viragem = clamp(angulo_de_viragem, -max_turn_angle, max_turn_angle);
        }
        // --- CORREÇÃO: Usa a referência global para o objetivo ---
        var dir_para_objetivo = direcao_movimento;
        if (instance_exists(global.goal_id)) {
            dir_para_objetivo = point_direction(x, y, global.goal_id.x, global.goal_id.y);
        }
        var dir_final = dir_para_objetivo + angulo_de_viragem;
        var diff = angle_difference(direcao_movimento, dir_final);
        direcao_movimento -= diff * 0.2; 
        break;

    case ESTADO.ESCAPANDO:
        // --- MANOBRA DE FUGA: SEGUIR A PAREDE PELA DIREITA ---
        escape_timer--;
        var taxa_giro = 7.5;
        if (!leituras_sensores[3]) { // Se perdeu a parede à direita...
            direcao_movimento += taxa_giro; // ...vira para a direita para encontrá-la.
        } else if (!leituras_sensores[0]) { // Se tem parede à direita, mas livre à frente...
            // ...segue em frente.
        } else { // Se tem parede à direita E à frente (quina)...
            direcao_movimento -= taxa_giro; // ...vira para a esquerda para desviar.
        }
        if (escape_timer <= 0) {
            estado = ESTADO.BUSCANDO; // Termina a manobra de fuga
            estado_string = "Buscando";
        }
        break;
}

// --- 3. APLICAR MOVIMENTO COM DESLIZAMENTO DE COLISÃO ---
var h_speed = lengthdir_x(velocidade, direcao_movimento);
var v_speed = lengthdir_y(velocidade, direcao_movimento);

for (var i = 0; i < abs(h_speed); i++) {
    if (!place_meeting(x + sign(h_speed), y, obj_obstaculo)) { x += sign(h_speed); } else { break; }
}
for (var i = 0; i < abs(v_speed); i++) {
    if (!place_meeting(x, y + sign(v_speed), obj_obstaculo)) { y += sign(v_speed); } else { break; }
}

if (place_meeting(x, y, obj_obstaculo)) {
    is_collided = true;
    alarm[0] = 3 * room_speed;
}

x = clamp(x, 16, room_width - 16);
y = clamp(y, 16, room_height - 16);

// --- CORREÇÃO: Usa a referência global para o objetivo ---
if (instance_exists(global.goal_id)) {
    if (distance_to_object(global.goal_id) < 16) {
        global.last_run_result = "Sucesso!";
        global.last_run_time = time_elapsed;
        global.last_run_distance = distance_traveled;
        game_restart();
    }
}

// --- 4. GRAVAR DADOS NO LOG ---
var snapshot = ds_map_create();
ds_map_add(snapshot, "time", time_elapsed);
ds_map_add(snapshot, "x", x);
ds_map_add(snapshot, "y", y);
ds_map_add(snapshot, "direction", direcao_movimento);
ds_map_add(snapshot, "turn_angle", angulo_de_viragem);
ds_map_add(snapshot, "state", estado_string);
ds_list_add(log_data, snapshot);
