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
  
  )

)
