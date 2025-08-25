$fn = 64;

// Cable diameter. Usually a good idea to add 0.2 mm on top.
cable_diameter = 3.2;
// Cable direction. "horizontal" or "vertical"
orientation = "vertical";
// Side of cable clip relative to pegboard hole. "left" or "right"
cable_side = "right";
// Pegboard thickness. Usually 5mm
board_thickness = 5;

/* [Hidden] */
cable_radius = cable_diameter / 2;
board_hook_corner_radius = 2.5;
board_hook_tip_length = 12;
insert_width = 4.8;
corner_radius = 1.5;
clip_height = 10;
hook_tip_width = 2.5;

module corner(side = "left") {
  x_origin = side == "left" ? corner_radius : -corner_radius;

  translate([x_origin, corner_radius, 0])
    circle(r=corner_radius);
}

module cable_hook_cutout() {
  translate([insert_width + cable_radius, hook_tip_width + cable_radius, 0]) {
    circle(r=cable_radius);

    translate([-cable_radius, 0, 0])
      square([cable_radius * 2, cable_radius * 2]);
  }
}

module cable_clip() {
  linear_extrude(clip_height)
    difference() {
      hull() {
        corner(side="left");

        translate([insert_width + (cable_radius * 2) + hook_tip_width, 0, 0])
          corner(side="right");

        translate([0, corner_radius, 0])
          square([insert_width + (cable_radius * 2) + hook_tip_width, cable_radius * 2 + hook_tip_width - corner_radius]);
      }

      cable_hook_cutout();
    }
}

module board_hook_arm() {
  linear_extrude(insert_width)
    translate([0, cable_radius + hook_tip_width, 0])
      square([insert_width, cable_radius + board_thickness + board_hook_corner_radius * 2]);
}

module board_hook_tip() {
  linear_extrude(insert_width)
    translate([0, hook_tip_width + cable_radius * 2 + board_thickness, 0]) {
      hull() {
        square(board_hook_corner_radius * 2);
        translate([board_hook_tip_length - board_hook_corner_radius, board_hook_corner_radius, 0])
          circle(r=board_hook_corner_radius);
      }
    }
}

module vertical_left() {
  cable_clip();
  board_hook_arm();

  mirror([1, 0, 0])
    rotate([0, 270, 0])
      board_hook_tip();
}

module horizontal_left() {
  cable_clip();
  board_hook_arm();
  board_hook_tip();
}

if (orientation == "vertical" && cable_side == "left") {
  vertical_left();
} else if (orientation == "vertical" && cable_side == "right") {
  mirror([1, 0, 0])
    vertical_left();
} else if (orientation == "horizontal" && cable_side == "left") {
  horizontal_left();
} else if (orientation == "horizontal" && cable_side == "right") {
  mirror([1, 0, 0])
    horizontal_left();
}
