`timescale 1ns / 1ps

module RISCV_single_cycle_tb;

    // 1. Declaración de señales de estímulo
    reg clk;
    reg rst;

    // 2. Instanciación del procesador (Módulo Top)
    RISCV_single_cycle uut (
        .clk(clk),
        .rst(rst)
    );

    // 3. Generador de Reloj (Periodo de 10ns -> 100 MHz)
    always begin
        #5 clk = ~clk;
    end

    // 4. Bloque de estímulo principal
    initial begin
        // Inicializar señales de control
        clk = 0;
        rst = 1;
        
        // Inicializar valores en los registros usando la ruta de tu módulo 'Files'
        // Esto le da datos reales al programa para operar desde el inicio
        uut.Files.registers[5]  = 32'd15;  // x5 = 15
        uut.Files.registers[10] = 32'd25;  // x10 = 25
        uut.Files.registers[1]  = 32'd0;   // x1 = 0

        // Esperar 12ns (un momento desalineado del flanco) y liberar el reset
        #12; 
        rst = 0; 
        
        // 5. Tiempo total de ejecución
        // Dejamos correr la simulación por 250ns para procesar las 20 instrucciones
        #250;
        
        $display("Simulación terminada con éxito.");
        $finish;
    end

    // 6. Monitor de consola para verificar el avance del PC en la pestaña Transcript
    initial begin
        $monitor("Tiempo: %0t | PC: %h | Instrucción actual (RD): %h", $time, uut.PC, uut.RD);
    end

endmodule