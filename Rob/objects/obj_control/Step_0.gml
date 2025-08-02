if (keyboard_check_pressed(vk_space)) {
    // Salva o log no console antes de reiniciar
    if (instance_exists(obj_rob)) {
        show_debug_message("--- INÍCIO DO LOG DE TELEMETRIA ---");
        var log_list = obj_rob.log_data;
        for (var i = 0; i < ds_list_size(log_list); i++) {
            var snapshot = log_list[| i];
            var log_string = "T: " + string_format(snapshot[? "time"], 0, 2) +
                             " | Pos: (" + string(floor(snapshot[? "x"])) + "," + string(floor(snapshot[? "y"])) + ")" +
                             " | Dir: " + string_format(snapshot[? "direction"], 0, 1) +
                             " | TurnAngle: " + string_format(snapshot[? "turn_angle"], 0, 2) +
                             " | State: " + snapshot[? "state"];
            show_debug_message(log_string);
        }
        show_debug_message("--- FIM DO LOG DE TELEMETRIA ---");
    }
    game_restart();
}