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

  --Gets objects rotation
  objRot = obj.rotation
  objEulerRot = quatToEuler objRot
  objRot_X = objEulerRot.x as String
  objRot_Y = objEulerRot.y as String
  objRot_Z = objEulerRot.z as String
  objRotXYZ = ("X:" + objRot_X + "|Y:" + objRot_Y + "|Z:" + objRot_Z)
  if objRotXYZ == "X:0.0|Y:0.0|Z:0.0" then
  (
    objRotTF = "Correct"
  )
  else
  (
    objRotTF = "Not Correct"
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
  if selectedFace.count > 0 then
  (
    overlapperUV = "Overlap UV Detected"
  )
  else
  (
    overlappingUV = "Correct"
  )
  subobjectLevel = 0

  --Gets UV Channel Count
  uvChannels = polyop.getNumMaps obj
  if uvChannels <= 2 or uvChannes >= 4 then
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
    if (MatchPattern objMtlCheck pattern: "Multi*") then
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

  --creates a csv file
  if doesFileExist datafilePath
  (
    outFile = createfile datafilePath
    format "Name, Position, Position_Check, Rotation, Rotation_Check, Scale, Scale_Check, Polygon_Count, Vertex_Count, Dead_Structs, UV_Count, Lightmap_Channel_Overlap_Check, Lightmap_Overlapping_UVs File_Location, Material_Name\n"
    to:OutFile

    format "%,%,%,%,%,%,%,%,%,%,%,%,%,%\n" objName objposXYZ objPosTF objRotXYZ objTorTF objScaleXYZ objScaleTF objNumFaces objNumVerts deadstructs uvChannels overlappingUV uvChannelMessage file_Location, objMaterial to:outFile
    close outFile
  )
  else
  (
    outFile = openfile datafilePath mode:"a"
    format "%,%,%,%,%,%,%,%,%,%,%,%,%,%\n" objName objposXYZ objPosTF objRotXYZ objTorTF objScaleXYZ objScaleTF objNumFaces objNumVerts deadstructs uvChannels overlappingUV uvChannelMessage file_Location, objMaterial to:outFile
    close outFile
  )
  print("~~~" + obj.name + ": processed~~~")
  
  )
)

--resets the scene
reset_Scene()

--lets the user declare a root file path to look through
global rootFolder = getSavePath Caption: "Choose Folder Location" initialDir: (getDir #scene)

--Creates a FBX filepatten to look for
global filePattern = "\\*.fbx"

--Creates a file path to recurse search
global theFiles = getFiles (rootFodler + filePattern) recurse:true

--Creates the Data File Directory
global datafilePath = maxFilePath + "Datafile.csv"

--creats a progres count
totalFileCOunt = theFiles.count
global ProgressCount = 0

for f in theFiles do
(
  importFile f #noprompt

  progressCount += 1

  print(ProgressCount as string) + "/" + (totalFileCOunt as string)

  -checks for dummy objects and removes them
  for dummyObj in objects do
  (
    if isKindOf dummyObj Dummy then
    (
      --Clears any dummy geo would cause in error on import
      select geometry
      max unlink
      delete helpers

      logging f

      reset_Scene ()  
    )
    else
    (
      delete helpers
      logging f

      reset_Scene
    )
  )
)
