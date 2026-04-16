library verilog;
use verilog.vl_types.all;
entity key_scheduler is
    generic(
        WIDTH           : integer := 64
    );
    port(
        feistel_state   : in     vl_logic_vector(3 downto 0);
        key_in          : in     vl_logic_vector;
        decrypt         : in     vl_logic;
        K_out           : out    vl_logic_vector(47 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end key_scheduler;
