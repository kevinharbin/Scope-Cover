//scope cover version 1.2.1
//$fn = 128;
//all units mm
//https://openscad.cloud/openscad/ for testing
//adjust these two values
scope_Height = 6; //6 is usually right
scope_diameter= 28;//inside diameter, don't be too snug
//
paracord_diameter = 4.5;//diameter for paracord hole. for me the final size is 4mm, workout with printer settings for actual diameter
thumb_length = 12;
layer_height = .2; //not necessary to be changed
wall_thickness= 1;
paracord_offset = ((scope_diameter)/2+wall_thickness+paracord_diameter/2);
paracord_fill_offset = ((scope_diameter)/2+wall_thickness);


//voids
module voids(){
//paracord slot R
translate([-paracord_offset, 0, 0])
rotate_extrude(angle=360, convexity = 1, $fn=256)
translate([0, 0, 0])
polygon(points = [ 
    [0,0], //0
    [0,scope_Height+wall_thickness+1], //1
    [-(paracord_diameter/2+wall_thickness),scope_Height+wall_thickness+1], //2
    [-(paracord_diameter/2+wall_thickness),scope_Height+wall_thickness], //3
    [-(paracord_diameter/2+wall_thickness*.9),scope_Height+wall_thickness], //4
    [-(paracord_diameter/2+wall_thickness*.6),scope_Height+wall_thickness-layer_height], //5
    [-(paracord_diameter/2+wall_thickness*.3),scope_Height+wall_thickness-2*layer_height], //6
    [-(paracord_diameter/2+wall_thickness*.0),scope_Height+wall_thickness-3*layer_height], //7
    [-(paracord_diameter/2),0]//8
    ], paths = [ [0,1,2,3,4,5,6,7,8]], convexity = 0);

//paracord slot L
translate([paracord_offset, 0, 0])
rotate_extrude(angle=360, convexity = 1, $fn=256)
translate([0, 0, 0])
polygon(points = [ 
    [0,0], //0
    [0,scope_Height+wall_thickness+1], //1
    [-(paracord_diameter/2+wall_thickness),scope_Height+wall_thickness+1], //2
    [-(paracord_diameter/2+wall_thickness),scope_Height+wall_thickness], //3
    [-(paracord_diameter/2+wall_thickness*.9),scope_Height+wall_thickness], //4
    [-(paracord_diameter/2+wall_thickness*.6),scope_Height+wall_thickness-layer_height], //5
    [-(paracord_diameter/2+wall_thickness*.3),scope_Height+wall_thickness-2*layer_height], //6
    [-(paracord_diameter/2+wall_thickness*.0),scope_Height+wall_thickness-3*layer_height], //7
    [-(paracord_diameter/2),0]//8
    ], paths = [ [0,1,2,3,4,5,6,7,8]], convexity = 0);

//scope slot
translate([0, 0, 0])
rotate_extrude(angle=360, convexity = 1, $fn=256)
translate([0, 0, 0])
polygon(points = [ 
    [0,wall_thickness+2*layer_height], //0
    [0,scope_Height+wall_thickness+1], //1
    [-(scope_diameter/2+wall_thickness),scope_Height+wall_thickness+1], //2
    [-(scope_diameter/2+wall_thickness),scope_Height+wall_thickness], //3
    [-(scope_diameter/2+wall_thickness*.75),scope_Height+wall_thickness], //4
    [-(scope_diameter/2+wall_thickness*.5),scope_Height+wall_thickness-layer_height], //5
    [-(scope_diameter/2+wall_thickness*.25),scope_Height+wall_thickness-2*layer_height], //6
    [-(scope_diameter/2+wall_thickness*.0),scope_Height+wall_thickness-3*layer_height], //7
    [-(scope_diameter/2),wall_thickness+2*layer_height]//8
    ], paths = [ [0,1,2,3,4,5,6,7,8]], convexity = 0);

//thumb rounding
difference(){
cylinder(scope_Height, d=3*(scope_diameter/2+thumb_length), center=false);
cylinder(scope_Height, d=2*(scope_diameter/2+thumb_length), center=false);
};

//size imprint
translate([0, 0,wall_thickness]) {
    linear_extrude(height = scope_Height, center = false) 
resize([scope_diameter-2*wall_thickness, 0], auto = true)
   text(str(scope_diameter,"mm"), font = "Liberation Sans", halign="center", valign="center");
 }
}

module paracord_nub(dir){
translate([dir*paracord_offset, 0, 0])
cylinder(scope_Height+wall_thickness, d=paracord_diameter+wall_thickness*2, center=false);
translate([dir*paracord_fill_offset, -paracord_diameter/2.5, 0])
cylinder(scope_Height+wall_thickness, d=1.5*(paracord_diameter+wall_thickness), center=false);
}


difference(){
//solids
union(){
//paracord nub R
    paracord_nub(-1);

//paracord nub L
paracord_nub(1);

//scope nub 
translate([0, 0, 0])
cylinder(scope_Height+wall_thickness, d=scope_diameter+wall_thickness*2, center=false);

//thumb tab
   polyhedron( 
    points = [ 
        [0-((scope_diameter)/2+wall_thickness*2+paracord_diameter),0,0],
        [0-scope_diameter/3,scope_diameter/2+thumb_length,0],
        [scope_diameter/3,scope_diameter/2+thumb_length,0],
        [(scope_diameter)/2+wall_thickness*2+paracord_diameter,0,0],

        [0-((scope_diameter)/2+wall_thickness*2+paracord_diameter),0,scope_Height+wall_thickness],
        [0-scope_diameter/3,scope_diameter/2+thumb_length,1.5],
        [scope_diameter/3,scope_diameter/2+thumb_length,1.5],
        [((scope_diameter)/2+wall_thickness*2+paracord_diameter),0,scope_Height+wall_thickness]
    ],
    faces = [
        [1,2,6,5],
        [2,3,7,6],
        [3,0,4,7],
        [0,1,5,4],
        [0,3,2,1],
        [6,7,4,5]
    ]
);
}
//cut (difference) voids from solids
voids();
};
