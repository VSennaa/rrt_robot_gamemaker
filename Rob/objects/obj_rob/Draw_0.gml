
draw_self();

// Desenha a visualização de debug (sensores)
for (var i = 0; i < array_length(angulos_sensores); i++) {
    var angulo_sensor = direcao_movimento + angulos_sensores[i];
    var sensor_x_inicio = x + lengthdir_x(raio_robo, angulo_sensor);
    var sensor_y_inicio = y + lengthdir_y(raio_robo, angulo_sensor);
    var sensor_x_fim = sensor_x_inicio + lengthdir_x(distancia_sensor, angulo_sensor);
    var sensor_y_fim = sensor_y_inicio + lengthdir_y(distancia_sensor, angulo_sensor);
    var cor_sensor = leituras_sensores[i] ? c_red : c_lime;
    draw_line_color(sensor_x_inicio, sensor_y_inicio, sensor_x_fim, sensor_y_fim, cor_sensor, cor_sensor);
}
