if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}
randomize();

// --- MÉTRICAS PERSISTENTES ---
if (!variable_global_exists("last_run_result")) {
    global.last_run_result = "N/A";
    global.last_run_time = 0;
    global.last_run_distance = 0;
    global.goal_id = noone; // Inicializa a variável global do objetivo ( isso aq garante q ele não vá pra um lugar aleatório)
}

// --- CRIA O ROBÔ ---
instance_create_layer(16, 16, "Instances", obj_rob);

// --- CRIA A GRADE DE OBSTÁCULOS ---
var grid_width = room_width div 32;
var grid_height = room_height div 32;
var count = 0;
while (count < 50) {
    var x_cell = irandom(grid_width - 1);
    var y_cell = irandom(grid_height - 1);
    var px = x_cell * 32 + 16;
    var py = y_cell * 32 + 16;
    if (!position_meeting(px, py, all)) {
        instance_create_layer(x_cell * 32, y_cell * 32, "Instances", obj_obstaculo);
        count++;
    }
}

// --- CRIA O OBJETIVO (GOAL) ---
var goal_x = 768; // ultima linha
var goal_y;
var is_goal_pos_free = false;

// Cria o objetivo na ultima coluna em um Y aleatório
while (!is_goal_pos_free) {
    var goal_y_cell = irandom(grid_height - 1);
    goal_y = goal_y_cell * 32;
    if (!position_meeting(goal_x + 16, goal_y + 16, obj_obstaculo)) { // Garante que não haja obstaculo em cima do objetivo
        global.goal_id = instance_create_layer(goal_x, goal_y, "Instances", obj_goal);
        is_goal_pos_free = true;
    }
}