--This is a tool that helps QA FBX items from  repository

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

  --Gets the Objects poly count
  objNumFace = obj.numfaces

  --Gets the Vertex count
  objNumVerts = obj.numVerts

  --checks if dead structures are in the file
  if polyop.getHasDeadStructs obj > 0 then
  (
    deadstructs = True
  )
  else
  (
    deadstructs = False
  )

  --Checks for UV overlapping in the light channel
  channelInfo.CopyChannel obj 3 2
  channelInfo.PasteChannel obj 3 1
  channelInfo.NameChannel obj 3 1 "-none-"
  macros.run "Modifier Stack" "Convert_to_Poly"
  macros.run "xView" "xView_Overlapped_UVW_Faces_Checker"
  macros.run "xView" "xView_Select_Results"
  subobjectLEvel = 4
  macros.run "xView" "xView_Overlapped_UVW_Faces_Checker"
  selectedFace = obj.selectedFaces
  if selectedFace.count >0 then
  (
    overlapperUV = "Overlap UV Detected"
  )
  else
  (
    overlappingUV = "Correct"
  )
  subobjectLevel = 0

  --Gets UV Channel Count
  uvChannels <= 2 or uvChannes >= 4 then
  (
    uvChannelMessage = "Missing LIghtmap Channel or too many Channels"
  )
  else
  (
    uvChannelMessage = "Correct"
  )

  --Gets Materials
  if obj.material != undefined then
  (
    objMtlCheck = obj.material.name
    if (MatchPattern objMtlCheck pattern; "Multi*") then
    (
      objMaterial = obj.material.materialList as string
    )
    else
    (
      objMaterial = objMtlCheck
    )
  )

  --gets file location
  file_Location = f as string

  )
)
