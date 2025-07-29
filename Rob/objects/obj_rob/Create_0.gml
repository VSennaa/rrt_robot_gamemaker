obj_rob.x = 16; 
obj_rob.y = 16;

// --- MÁQUINA DE ESTADOS ---
enum ESTADO {
    BUSCANDO,    
    CONTORNANDO  
}
estado = ESTADO.BUSCANDO;

// --- MEMÓRIA INTERNA DO ROBÔ ---
enum CELULA {
    DESCONHECIDA, 
    LIVRE,        
    OBSTACULO     
}

// Cria uma grade para armazenar o mapa conhecido pelo robô.
var grid_w = room_width div 32; //  unidade de "bloco" 32x32
var grid_h = room_height div 32;
mapa_conhecido = ds_grid_create(grid_w, grid_h);
ds_grid_set_region(mapa_conhecido, 0, 0, grid_w - 1, grid_h - 1, CELULA.DESCONHECIDA);

// --- ATRIBUTOS DE MOVIMENTO E SENSORES ---
velocidade = 2.5; // Velocidade de movimento do robô em pixels por step.
direcao_movimento = 0; // graus.
distancia_sensor = 48; // O alcance da "visão" do robô.

// Configuração dos 5 sensores (ângulos em relação à direção do robô)
// [0] = Frente, [1] = Frente-Direita, [2] = Direita, [3] = Frente-Esquerda, [4] = Esquerda
angulos_sensores = [-45, -90, 0, 45, 90]; 
// Armazena o resultado da leitura de cada sensor (true se detectou algo, false caso contrário).
leituras_sensores = array_create(5, false);