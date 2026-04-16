library verilog;
use verilog.vl_types.all;
entity IP is
    port(
        \in\            : in     vl_logic_vector(63 downto 0);
        \out\           : out    vl_logic_vector(63 downto 0)
    );
end IP;
