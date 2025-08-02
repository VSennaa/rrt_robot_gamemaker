// --- MÉTRICAS DA TENTATIVA ATUAL ---
time_elapsed = 0;
distance_traveled = 0;
prev_x = x;
prev_y = y;
is_collided = false;

// --- ESTRUTURA DE LOG ---
log_data = ds_list_create();

// MÁQUINA DE ESTADOS 
enum ESTADO { BUSCANDO, ESCAPANDO }
estado = ESTADO.BUSCANDO;

estado_string = "Buscando";

// --- Variáveis para Deteção de Estagnação ---
stuck_check_timer = 0;
stuck_check_pos_x = x;
stuck_check_pos_y = y;
escape_timer = 0;

// --- ATRIBUTOS DE MOVIMENTO E SENSORES ---
velocidade = 1.5;
direcao_movimento = 0;
distancia_sensor = 100;
raio_robo = 12;
margem_seguranca = 8;
max_turn_angle = 35;

// --- SENSORES (Máximo 5) ---
angulos_sensores = [0, 45, -45, 90, -90]; // Frente, Frente-Direita, Frente-Esquerda, Direita, Esquerda
leituras_sensores = array_create(array_length(angulos_sensores), false);
distancias_sensores = array_create(array_length(angulos_sensores), -1);

