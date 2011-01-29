/*
 *    Buzzbomb-keyfob 
 *    Copyright 2011, Stephen M. Cameron 
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; version 2 of the License.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
 *    NON INFRINGEMENT.  See the GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

electronics_diameter = 31;
electronics_height = 8;

inner_diameter = electronics_diameter + 2;
outer_diameter = inner_diameter + 6;
inner_height = electronics_height + 3;
outer_height = electronics_height + 4;

keyhead_x = 15;
keyhead_y = 26;
keyhead_z = 3;
keyshaft_width = 11;

keyblock_height = keyhead_z + 6;
keyblock_length = keyhead_x + 17;
keyblock_width = keyhead_y + 6 ;
keyblock_x_offset = keyblock_length / 2 + outer_diameter / 2 - 14;

small_button_r = 3.7;
large_button_r = 4.3;

module keyring()
{
	difference() {
		cylinder (h = 3, r1 = 7, r2 = 7, center = true);
		cylinder (h = 4, r1 = 4.5, r2 = 4.5, center = true);
	}
}

module sharp_edge_1()
{
	translate( [ 23, -16,  -4] )
		rotate( a = [45, -4.5, 0])
			cube( [ keyblock_length , 3, 3], center = true );
}


module sharp_edge_2()
{
	translate( [ 23, 16,  -4] )
		rotate( a = [45, -4.5, 0])
			cube( [ keyblock_length , 3, 3], center = true );
}

module sharp_edge_3()
{
	translate( [ 30,  16,  7] )
		rotate( a = [45, 4.5, 0])
			cube( [ keyblock_length , 3, 3], center = true );
}

module sharp_edge_4()
{
	translate( [ 30,  -16,  7] )
		rotate( a = [45, 4.5, 0])
			cube( [ keyblock_length , 3, 3], center = true );
}

module sharp_edge_6()
{
	translate( [ 37.7, 0, 6])
		rotate( a = [0, 45, 0])
			cube( [2, 40, 2], center = true);
}

module sharp_edge_5(y)
{
	translate( [ 37.7, y * 16, 0 ])
		rotate( a = [0, 0, 45])
			cube( [3, 3, 20], center = true);
}

module sharp_edge_7()
{
	translate( [ 37.7, 0, -3.2])
		rotate( a = [0, 45, 0])
			cube( [2, 40, 2], center = true);
}

module keyshaft_void()
{
	translate( [keyblock_length + 5, 0, 7.5])
	cube( [10, 10, keyshaft_width], center = true);
}

module keyblock_void()
{
	translate( [keyblock_x_offset + 5.5, 0, 5])
		cube ([keyhead_x, keyhead_y, keyhead_z * 2], center = true);
}


module keyblock()
{
	translate( [keyblock_x_offset,  0,  1.5 ])
		cube( [keyblock_length , keyblock_width, keyblock_height] , center = true);
}

module casing_bottom_cylinder()
{
	union() {
		cube(1, 1, 1);
		cylinder(h = outer_height , r1 = outer_diameter / 2, r2 = outer_diameter / 2);
		translate( [0, 0, -outer_height / 4] )
			cylinder(h = outer_height / 4, r2 = outer_diameter / 2, r1 = (outer_diameter - outer_height / 4) / 2);
		keyblock();
		translate ( [ -18, 0, -1.5 ])
			keyring();
	}
}

module casing_bottom_void()
{
	translate( [ 0, 0, 4] ) {
		union () {
			cylinder( h = inner_height  + 3, r1 = inner_diameter / 2, r2 = inner_diameter / 2);
			translate( [0, 0,  inner_height / 2 ])
				cylinder( h = inner_height / 2 + 2, r1 = (inner_diameter + 3) / 2, r2 = (inner_diameter + 3) / 2 );
		}
	}
}

module anti_rotation_block()
{
	translate([14.5, 0,  3])
		cube( [3.75, 21, 12], center = true);
}


module casing_bottom()
{
	
	casing_bottom_cylinder();
}

module casing()
{
	union() {
		difference() {
			casing_bottom();
			casing_bottom_void();
			keyblock_void();
			keyshaft_void();
			sharp_edge_1();
			sharp_edge_2();
			sharp_edge_3();
			sharp_edge_4();
			sharp_edge_5(1);
			sharp_edge_5(-1);
			sharp_edge_6();
			sharp_edge_7();
		}
		anti_rotation_block();
	}
}

module button_hole(x, y, z, r)
{
	translate( [x, y, z]) {
		union() {
			cylinder( h = 10 , r1 = r+0.3, r2 = r+0.3, center = true);
			translate([0, 0, 4])
				cylinder( h = 3, r1 = r + 0.3, r2 = r + 2.7, center = true);
		}
	}
}

module button(x, y, z, r, nubbin)
{
	translate( [x, y, z])
		union() {
			cylinder( h = 4, r1 = r - 0.3, r2 = r - 0.3, center = true);
			translate([0, 0, -2])
				cylinder( h = 2, r1 = r, r2 = r  + 1.5, center = true);
			translate([0, 0, 2.5])
				cylinder(h = 1, r1 = r - 0.3, r2 = r - 1, center = true);
			if (nubbin > 0) {
				translate([0, 0, 2.5])
					cylinder(h = 2, r1 = 1, r2 = 1, center = true);
			}
		}
}

module top_cylinder_void(x, y, z)
{
	tcvr = inner_diameter / 2 - 2;

	translate ([x, y, z]) {
		difference() {
			cylinder( h = 3, r1 = tcvr, r2 = tcvr, center = true);
			translate( [ -tcvr, 0, 0])
				cube( [ tcvr * 2, tcvr * 2, 6], center = true);
		}
	}
}

module top_cylinder()
{
	translate( [0, 0,  20 ]) {
		difference() {
			union() {		
				cylinder( h = 2, r1 = (inner_diameter  + 1.5) / 2, r2 = (inner_diameter  + 1.5) / 2 );
				translate( [0, 0, 2] )
					cylinder(h = outer_height / 6, r1 = outer_diameter / 2, r2 = (outer_diameter - outer_height / 4) / 2);
			}
			button_hole(-7, 7, 0, small_button_r);
			button_hole(-7, -7, 0, large_button_r);
			top_cylinder_void(0, 0, 0.2);
		}
		// top_cylinder_void(0, 0, 0.2);
	}		
}

//$fa=6;
//$fn=40;

casing();

rotate([180, 0, 0])
	top_cylinder();

translate( [0, 0,  20 ]) {
	button(-7, 7, 20, small_button_r, 0);
	button(-7, -7, 20, large_button_r, 1);
}


//keyblock_void();
//keyshaft_void();
//sharp_edge_3();
//sharp_edge_5();




