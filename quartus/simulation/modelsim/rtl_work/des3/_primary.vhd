library verilog;
use verilog.vl_types.all;
entity des3 is
    generic(
        WIDTH           : integer := 64
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        idata           : in     vl_logic_vector;
        key1            : in     vl_logic_vector;
        key2            : in     vl_logic_vector;
        key3            : in     vl_logic_vector;
        valid_in        : in     vl_logic;
        odata           : out    vl_logic_vector;
        valid_out       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end des3;
