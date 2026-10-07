// Exporta um circuito Digital (.dig) para Verilog, equivalente a File - Export - Export to Verilog.
// Uso: java -cp Digital.jar scripts/ExportVerilog.java <circuito.dig> <saida.v>
import de.neemann.digital.cli.CircuitLoader;
import de.neemann.digital.hdl.printer.CodePrinter;
import de.neemann.digital.hdl.verilog2.VerilogGenerator;
import java.io.File;

public class ExportVerilog {
    public static void main(String[] args) throws Exception {
        CircuitLoader loader = new CircuitLoader(new File(args[0]));
        try (VerilogGenerator gen = new VerilogGenerator(loader.getLibrary(), new CodePrinter(new File(args[1])))) {
            gen.export(loader.getCircuit());
        }
    }
}
