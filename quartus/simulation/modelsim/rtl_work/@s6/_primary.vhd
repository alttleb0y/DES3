library verilog;
use verilog.vl_types.all;
entity S6 is
    port(
        \in\            : in     vl_logic_vector(5 downto 0);
        \out\           : out    vl_logic_vector(3 downto 0)
    );
end S6;
