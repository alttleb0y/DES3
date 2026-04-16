library verilog;
use verilog.vl_types.all;
entity f is
    port(
        R               : in     vl_logic_vector(31 downto 0);
        K               : in     vl_logic_vector(47 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end f;
