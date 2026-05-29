`timescale 1ns / 1ps

module RISCV_single_cycle_tb;

    reg clk;
    reg rst;

    RISCV_single_cycle uut (
        .clk(clk),
        .rst(rst)
    );

    // Generador de reloj
    always begin
        #5 clk = ~clk;
    end

    // Bloque de estímulos
    initial begin
        clk = 0;
        rst = 1; // Mantiene el sistema congelado al inicio
        
        // Carga de datos iniciales directamente en el Banco de Registros (x5, x10, x1)
        uut.Files.registers[5]  = 32'd15;  
        uut.Files.registers[10] = 32'd25;  
        uut.Files.registers[1]  = 32'd0;   

        #12; 
        rst = 0; // Libera el reset para arrancar el procesador
        
        #250;    // Tiempo suficiente para ejecutar las 20 instrucciones del programa
        
        $display("Simulación terminada con éxito.");
        $finish; // Detiene la ejecución en Questa
    end

    initial begin
        $monitor("Tiempo: %0t | PC: %h | Instrucción actual (RD): %h", $time, uut.PC, uut.RD);
    end

endmodule