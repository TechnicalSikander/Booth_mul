`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT JAMMU
// Engineer: M.Sikander Sheikh
// 
// Create Date: 19.07.2025 16:59:12
// Design Name: Booth_multiplier
// Module Name: booth_mul
// Project Name: booth8x8
// Target Devices: 
// Tool Versions: 
// Description:8x8 booth multiplier with CLA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module booth_mul(
input [7:0]a,b,
output [15:0]m
    );    
wire [8:0] x1,x2,x3,x4,x5;
assign {x1[8],x1[7:1],x1[0]}={~a[7],a[6:0],1'b0};
assign {x2[8],x2[7:0]}={~a[7],a};
assign {x3[8],x3[7:0]}=9'b100000000;
assign x4[7:0]=~a+1;
assign x4[8]=~x4[7];
assign {x5[8],x5[7:1],x5[0]}={~x4[7],x4[6:0],1'b0};
wire [8:0]p1,p2,p3,p4;
wire [2:0]s1,c1;
wire [6:0]s2,c2;
wire [10:0]s3,c3;
wire [7:0]cv;
assign cv=8'hab;
mux4x1 m1(x3,x2,x5,x4,b[1:0],p1);
//mux m1(x1,x2,x3,x4,x5,{b[1:0],1'b0},p1);
mux m2(x1,x2,x3,x4,x5,b[3:1],p2);
mux m3(x1,x2,x3,x4,x5,b[5:3],p3);
mux m4(x1,x2,x3,x4,x5,b[7:5],p4);

ha h1(p1[8],p2[6],s1[0],c1[0]);
ha h2(p2[7],p3[5],s1[1],c1[1]);
ha h3(p2[8],p3[6],s1[2],c1[2]);

ha h4(p1[6],p2[4],s2[0],c2[0]);
fa f1(p1[7],p2[5],p3[3],s2[1],c2[1]);
fa f2(s1[0],p3[4],p4[2],s2[2],c2[2]);
fa f3(c1[0],s1[1],p4[3],s2[3],c2[3]);
fa f4(c1[1],s1[2],p4[4],s2[4],c2[4]);
fa f5(c1[2],p4[5],p3[7],s2[5],c2[5]);
ha h5(p3[8],p4[6],s2[6],c2[6]);

ha h6(p1[4],p2[2],s3[0],c3[0]);
fa f6(p1[5],p2[3],p3[1],s3[1],c3[1]);
fa f7(p3[2],p4[0],s2[0],s3[2],c3[2]);
fa f8(c2[0],s2[1],p4[1],s3[3],c3[3]);
fa f9(c2[1],s2[2],cv[0],s3[4],c3[4]);
fa f10(c2[2],s2[3],cv[1],s3[5],c3[5]);
fa f11(c2[3],s2[4],cv[2],s3[6],c3[6]);
fa f12(c2[4],s2[5],cv[3],s3[7],c3[7]);
fa f13(c2[5],s2[6],cv[4],s3[8],c3[8]);
fa f14(c2[6],p4[7],cv[5],s3[9],c3[9]);
ha h7(p4[8],cv[6],s3[10],c3[10]);
wire [15:0]s,c;
assign s={cv[7],s3[10:0],p1[3:0]};
assign c={c3[10:0],p3[0],p2[1:0],2'b00};
cla_16 cla(s,c,1'b0,p,g,m,cy);

endmodule

module mux4x1(
input [8:0]i1,i2,i3,i4,
input [1:0]s,
output reg[8:0]o
);
always@(*)
begin 
case (s)
2'b00 : o = i1;
2'b01 : o = i2;
2'b10 : o = i3;
2'b11 : o = i4;
default : o =0;
endcase 
end 
endmodule 

module mux(
input [8:0]i1,i2,i3,i4,i5,
input [2:0]s,
output reg[8:0]o
);
always@(*)
begin 
case (s)
3'b000 : o = i3;
3'b001 : o = i2;
3'b010 : o = i2;
3'b011 : o = i1;
3'b100 : o = i5;
3'b101 : o = i4;
3'b110 : o = i4;
3'b111 : o = i3;
default : o =0;
endcase 
end 
endmodule 

module ha (
    input a,
    input b,
    output s,
    output c
);
    assign s = a ^ b;     
    assign c = a & b;  
endmodule


module fa (
    input a,
    input b,
    input cin,     
    output s,
    output c   
);
    assign s  = a ^ b ^ cin;
    assign c = (a & b) | (b & cin) | (a & cin);
endmodule




module add(
input a,
input b,
input cin,
output p,g,s
);

assign p = a^b;
assign g = a&b;
assign s=p^cin;

endmodule 


module cla_16(
input [15:0]a,b,
input c0,
output [15:0]p,g,s,
output cy

    );
wire [4:0]P,G;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15;
add a0(a[0],b[0],c0,p[0],g[0],s[0]);
add a1(a[1],b[1],c1,p[1],g[1],s[1]);
add a2(a[2],b[2],c2,p[2],g[2],s[2]);
add a3(a[3],b[3],c3,p[3],g[3],s[3]);
cla c00(p[3:0],g[3:0],c0,c1,c2,c3,P[0],G[0]);

add a4(a[4],b[4],c4,p[4],g[4],s[4]);
add a5(a[5],b[5],c5,p[5],g[5],s[5]);
add a6(a[6],b[6],c6,p[6],g[6],s[6]);
add a7(a[7],b[7],c7,p[7],g[7],s[7]);
cla c01(p[7:4],g[7:4],c4,c5,c6,c7,P[1],G[1]);

add a8(a[8],b[8],c8,p[8],g[8],s[8]);
add a9(a[9],b[9],c9,p[9],g[9],s[9]);
add a10(a[10],b[10],c10,p[10],g[10],s[10]);
add a11(a[11],b[11],c11,p[11],g[11],s[11]);
cla c02(p[11:8],g[11:8],c8,c9,c10,c11,P[2],G[2]);

add a12(a[12],b[12],c12,p[12],g[12],s[12]);
add a13(a[13],b[13],c13,p[13],g[13],s[13]);
add a14(a[14],b[14],c14,p[14],g[14],s[14]);
add a15(a[15],b[15],c15,p[15],g[15],s[15]);
cla c03(p[15:12],g[15:12],c12,c13,c14,c15,P[3],G[3]);

cla c04(P[3:0],G[3:0],c0,c4,c8,c12,P[4],G[4]);   
assign cy =P[4]&c15|G[4];
endmodule

module cla(
input [3:0]p,g,
input c0,
output c1,c2,c3,
output P,G
);
wire x,y;
assign c1=(p[0]&c0)|g[0];
assign c2=p[1]&c1|g[1];
assign c3=p[2]&c2|g[2];
assign P=&p;
assign x=&{p[1],p[2],p[3],g[0]};
assign y=&{p[3],p[2],g[1]};
assign G=g[3]|(p[3]&g[2])|y|x;

endmodule 


