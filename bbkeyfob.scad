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

/* For exporting to STL, do each part separately, change
   all but one of the three I_want_the_... variables to 0
   leaving only one of them set to 1, then render (F6),
   then export to STL.
*/
I_want_the_casing = 1;
I_want_the_lid = 1;
I_want_the_buttons = 1;

// for smoother (but more time consuming) rendering, uncomment these
// $fa=3;
// $fn=40;

electronics_diameter = 30;
electronics_height = 8;

inner_diameter = electronics_diameter + 2;
outer_diameter = inner_diameter + 6;
inner_height = electronics_height + 3 ;
outer_height = electronics_height + 4;

keyhead_x = 15;
keyhead_y = 26;
keyhead_z = 5;
keyshaft_width = 11;

keyblock_height = keyhead_z + 4;
keyblock_length = keyhead_x + 17;
keyblock_width = keyhead_y + 6 ;
keyblock_x_offset = keyblock_length / 2 + outer_diameter / 2 - 14;

small_button_r = 3.7;
large_button_r = 4.3;

module keyring()
{
	difference() {
		cylinder (h = 3, r1 = 7, r2 = 7, center = true);
		cylinder (h = 4, r1 = 5, r2 = 5, center = true);
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
	translate( [ 36.7, 0, 6])
		rotate( a = [0, 45, 0])
			cube( [2, 40, 2], center = true);
}

module sharp_edge_5(y)
{
	translate( [ 36.7, y * 16, 0 ])
		rotate( a = [0, 0, 45])
			cube( [3, 3, 20], center = true);
}

module sharp_edge_7()
{
	translate( [ 36.7, 0, -3.2])
		rotate( a = [0, 45, 0])
			cube( [2, 40, 2], center = true);
}

module keyshaft_void()
{
	translate( [keyblock_length + 5, 0, 5.5])
	cube( [10, keyshaft_width, 10.25], center = true);
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
	translate( [ 0, 0, 0] ) {
		union () {
			cylinder( h = inner_height  + 20, r1 = inner_diameter / 2, r2 = inner_diameter / 2);
			translate( [0, 0,  inner_height / 2 - 3 ])
				cylinder( h = inner_height / 2 + 6, r1 = (inner_diameter + 4) / 2, r2 = (inner_diameter + 4) / 2 );
		}
	}
}

module anti_rotation_block()
{
	translate([-16, 0,  2.7])
		cube( [4, 8, 7], center = true);
}


module casing_bottom()
{
	
	casing_bottom_cylinder();
}

module shave_top()
{
	translate([0, 0, 11])
		cube([50, 50, 5], center = true);
}

module battery_holder(x, y, z)
{
	br = 11; // battery radius
	bhod = br + 2; // battery holder outer diameter
	bhid = br + 1; // battery holder inner diameter
	bhh = 6; // battery holder height
	translate([x, y, z]) {
		difference() {
			cylinder(h = bhh, r1 = bhod, r2 = bhod,
				center = true); 
			cylinder(h = bhh, r1 = bhid, r2 = bhid,
				center = true); 
		}
	}
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
			shave_top();
		}
		anti_rotation_block();
		battery_holder(0, 0, 0);
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
	tcvr = inner_diameter / 2; // top cyl void radius

	translate ([x, y, z]) {
		cylinder( h = 8, r1 = tcvr, r2 = tcvr, center = true);
/*
		difference() {
			cylinder( h = 8, r1 = tcvr, r2 = tcvr, center = true);
			translate( [ -tcvr, 0, 0])
				cube( [ tcvr * 2, tcvr * 2, 6], center = true);
		}
*/
	}
}

module top_cylinder()
{
	lid_z_translate = 20;
	// lid_z_translate = -5; // use -5 to check fit
	lod = (inner_diameter + 2) / 2; // lid outer diameter
	todb = outer_diameter / 2; // top outer diameter big
	tods = (outer_diameter - outer_height / 4) / 2; // top outer diameter small
	
	translate( [0, 0,  lid_z_translate ]) {
		difference() {
			union() {		
				translate([0, 0, -4])
					cylinder( h = 6, r1 = lod, r2 = lod);
				translate( [0, 0, 2] )
					cylinder(h = outer_height / 6, r1 = todb, r2 = tods);
			}
			button_hole(-7, 7, 0, small_button_r);
			button_hole(-7, -7, 0, large_button_r);
			top_cylinder_void(0, 0, -2);
			translate([inner_diameter / 2, 0,  -4])
				cube([9, 10, 9], center = true);
		}
		// top_cylinder_void(0, 0, 0.2);	
	}		
}


if (I_want_the_casing > 0)
		casing();

if (I_want_the_lid > 0)
	rotate([180, 0, 0])
		top_cylinder();

if (I_want_the_buttons > 0)
	translate( [0, 0,  20 ]) {
		button(-7, 7, 20, small_button_r, 0);
		button(-7, -7, 20, large_button_r, 1);
	}



//keyblock_void();
//keyshaft_void();
//sharp_edge_3();
//sharp_edge_5();
//sharp_edge_6();

/*
translate([0, 0, -100])
	casing_bottom_void();
*/




