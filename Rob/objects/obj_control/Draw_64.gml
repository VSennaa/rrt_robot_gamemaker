// Define a fonte e o alinhamento para o texto
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// --- DESENHAR PAINEL DE DEBUG (Sempre ativo) ---
if (instance_exists(obj_rob)) {
    var y_offset = 500;
    
    // Coordenadas
    var robot_coords = "Robô (X,Y): (" + string(floor(obj_rob.x)) + ", " + string(floor(obj_rob.y)) + ")";
    draw_text(10, y_offset, robot_coords);
    y_offset += 20;
    
    // Distâncias dos sensores
    draw_text(10, y_offset, "Distâncias dos Sensores:");
    y_offset += 20;
    
    for (var i = 0; i < array_length(obj_rob.distancias_sensores); i++) {
        var sensor_dist_text = "  Sensor " + string(i) + " (" + string(obj_rob.angulos_sensores[i]) + "°): ";
        var dist = obj_rob.distancias_sensores[i];
        sensor_dist_text += (dist == -1) ? "> " + string(obj_rob.distancia_sensor) : string_format(dist, 0, 1);
        draw_text(10, y_offset, sensor_dist_text);
        y_offset += 15;
    }
}
