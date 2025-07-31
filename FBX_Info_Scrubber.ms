fn reet_Scene = --resets the scene function
(
delete objects
delte cameras
macros.run "Medt Tools" "clear_medit_slots"
)

fn logging f =
(
  for obj in objects do
  (
  Print("~~~" + obj.name + ": Started~~~")

  convertTo obj Editable_Poly
  --Gets name as a string
  objName = obj.name as string

  --gets Objetcs position
  obj_pos_X = (coordsys world obj.pos.x) as string
  obj_pos_Y = (coordsys world obj.pos.y) as string
  obj_pos_Z = (coordsys world obj.pos.z) as string
  obj_pos_XYZ = ("X:" + objpos_X + "|Y:" + objpos_Y + "|Z:" + objpos_Z)

  if objposXYZ == "X:0.0|Y:0.0|Z:0.0" then
  (
    objPosTF = "Correct"
  )
  else
  (
    objPosTF = "Not Correct"
  )
  )

)
