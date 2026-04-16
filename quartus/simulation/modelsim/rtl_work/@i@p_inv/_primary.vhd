library verilog;
use verilog.vl_types.all;
entity IP_inv is
    port(
        \in\            : in     vl_logic_vector(63 downto 0);
        \out\           : out    vl_logic_vector(63 downto 0)
    );
end IP_inv;
