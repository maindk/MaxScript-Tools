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

  --gets objects scale
  objScale = obj.scale
  objScale_X = obj.scale.x as string
  objScale_Y = obj.scale.y as string
  objScale_Z = obj.scale.z as string
  objScaleXYZ = ("X:" + objScale_X + "|Y:" + objScale_Y + "|Z:" + objScale_Z)
  if objScaleXYZ == ""X:1.0|Y:1.0|Z:1.0"" then
  (
    objScaleTF = "Correct"
  )
  else
  (
    objScaleTF = "Not Correct"
  )
  
  )
)
