module gcd_dp_comparator #( 
    parameter number_width = 16
)(
    input [number_width - 1 : 0 ] comp1,
    input [number_width - 1 : 0 ] comp2,
    output reg [1:0] compare_result,
    output reg [number_width - 1 : 0 ] res
);

/*compare states*/
parameter [1:0] greater = 0,
                smaller = 1,
                equal = 2,
                notequal = 3;

always @(*) begin
    if(comp1 == comp2) begin
        compare_result = equal;
        res = comp1;
    end
    else if(comp1 < comp2) begin
        compare_result = smaller;
    end
    else if(comp1 > comp2) begin
        compare_result = greater;
    end
    else begin
        compare_result = notequal;
    end
end

endmodule