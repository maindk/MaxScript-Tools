fn reset_Scene = --resets the scene
(
  delete objetcs
  delete cameras

  if batchrenderMgr.numViews != 0 do
  (
    for v = 1 to batchRenderMgr.numViews do
    (
      batchRenderMgr.DeleteView 1
    )
  )
  macros.run "Medit Tools" "clear_medit_slots"
)

fn global_Renders_Settings = --sets up the render scene
(
  rendForce2Side = true
  rendAtmosphere = false
  renderEffects = false
  renderDisplacements = false
  RadiosityPreference.useAdvancedLighting = false

  useEnvironmentMap = on
  backgroundColor = color 255 255 255
  SceneExposureControl.exposureControl = Automatic_Exposure_Control()
  ScneExposureControl.exposureControl.brightness = 32
  SceneExposureControl.exposureControl.contrast = 35
  SceneExposureControl.exposureControl.exposureValue = 0.6
  SceneExposureControl.exposureControl.physicalScale = 1500

  if renderers.current != Default_Scanline_Renderer then
  (
    renderers.current = Default_Scanline_Renderer()
  )
  renderers.production.Shadows = false
)

fn importFunctions = --imports the objects
(
  (
  global pngfileFormat = ".png"
  global pngfileFormat = ".tga"
  global pngfileFormat = ".tif"

  global pngfileFormat = ".png"
  types:"FBX (*.fbx) | *.fbx"
  importFile importedFBX #noPrompt
  FBXImporterSetParam "UpAxis" "Z"
  )

  for dummyObj in objetcs do
  (
    if classOf dummyObj == Dummy do
    (
      select (for geoObj in objects where superSclassOf obj == GeometryClass collect obj)
      max unlink
      select (for dummyObj in objects where superClassOf obj == helper and classOf obj == dummy collect obj)
      delete helpers
    )
  )

  global baseName = trimRight (getFilenameFile importFBX)
  global formatType = getFilenameType importedFBX
  global filePath - getFilenamePath importedFBX
)

fn cam_Setup camArray filePath pngfileFormat obj = --sets up the camarray, creats the cameras to render from and exports the rendered iages to where the object is imported from
(
  global camArray = #()"Front_Cam", "Back_Cam", "Left_Cam", "Right_Cam", "Ortho_Cam"
  --cameras
  renderOutputDirectory = filePath
  print("Render: " + renderOutputDirectory)

  deleteFile (renderOutputDirectory + "\\* + pngFileFormat)

  Front_Cam = Targetcamera pos:[0,-45,0] target:(Targetobject pos:[0,0,0]) name:"Front_Cam"
  Right_Cam = Targetcamera pos:[45,0,0] target:(Targetobject pos:[0,0,0]) name:"Right_Cam"
  Back_Cam = Targetcamera pos:[0,-45,0] target:(Targetobject pos:[0,0,0]) name:"Back_Cam"
  Left_Cam = Targetcamera pos:[-45,0,0] target:(Targetobject pos:[0,0,0]) name:"Left_Cam"
  Ortho_Cam = Targetcamera pos:[30,30,30] target:(Targetobject pos:[0,0,0]) name:"Ortho_Cam"

  --front camera
  frontCamObj = getNodeByName camArray[1]
  frontCamBatch = batchRenderMgr.CreateView frontCamobj
  frontNameCam = frontCamObj.name
  frontCamBatch.name = frontNameCam
  deleteFile (renderOutputDirectory + obj.name + "_" + frontNameCam + pngFileFormat)
  frontCamBatch.outputFilename = renderOutputDirectory + obj.name + "_" + frontNameCam + pngfileFormat)

  --back camera
  backCamObj = getNodeByName camArray[2]
  backCamBatch = batchRenderMgr.CreateView backCamObj
  backNameCam = backCamObj.name
  backCamBatch.name = backNameCam
  deleteFile (renderOutputDirectory + obj.name + "_" + backNameCam + pngFileFormat)
  backCamBatch.outputFilename = renderOutputDirectory + obj.name + "_" + backNameCam + pngfileFormat)

  --Left camera
  leftCamObj = getNodeByName camArray[3]
  leftCamBatch = batchRenderMgr.CreateView leftCamobj
  leftNameCam = leftCamObj.name
  eftCamBatch.name = leftNameCam
  deleteFile (renderOutputDirectory + obj.name + "_" + leftNameCam + pngFileFormat)
  leftCamBatch.outputFilename = renderOutputDirectory + obj.name + "_" + leftNameCam + pngfileFormat)

  --Right camera
  rightCamObj = getNodeByName camArray[4]
  rightCamBatch = batchRenderMgr.CreateView rightCamobj
  rightNameCam = rightCamObj.name
  rightCamBatch.name = rightNameCam
  deleteFile (renderOutputDirectory + obj.name + "_" + rightNameCam + pngFileFormat)
  rightCamBatch.outputFilename = renderOutputDirectory + obj.name + "_" + rightNameCam + pngfileFormat)

  --Ortho camera
  orthoCamObj = getNodeByName camArray[5]
  orthoCamBatch = batchRenderMgr.CreateView orthoCamobj
  orthoNameCam = orthoCamObj.name
  orthoCamBatch.name = orthoNameCam
  deleteFile (renderOutputDirectory + obj.name + "_" + orthoNameCam + pngFileFormat)
  orthoCamBatch.outputFilename = renderOutputDirectory + obj.name + "_" + orthoNameCam + pngfileFormat)

  --renders the Images
  batchRenderMgr.render()
  --removes the batch cams
  if batchRenderMgr.numViews != 0 do
  (
    for v = 1 to batchRenderMgr.numViews do
    (
      batchRenderMgr.DeleteView 1
    )
  )

  --removes cameras
  delete cameras

  --closes the render view
  actionMan.executeAction 0 "348"
)

fn bounding_Box_Measure = --measures the imported object and scales them to fit the rneder area for tha camera
(
  --grabs the measurements of the bounding box
  for measureObj in objects do
  (
    global intScale =1
    bb = nodeLocalBoundingBox measureObj
    pmin = bb[1]
    pmax = bb[2]
    global dx = (pmax.x - pmin.x)
    global dy = (pmax.y - pmin.y)
    global dz = (pmax.z - pmin.z)

    if dx > 30 or dy > 30 or dz > 30 then
    (
      intScale - .75
    )
    else if dx > 30 or dy > 30 or dz > 30 then
    (
      intScale - .75
    )
  )
)

fn matAssignment camArray obj = --converts the pyhiscal base material ot a standard legacy material. Assgins the texturemap to that material and assigns it on the object. This is still broken
(
  global pinkMat = Standardmaterial name:"PinkMaterial
  global importedTextureMap = Standardmaterial name:"IMported_TextureMap"

  if importedFBX != undefined do
  (
    importedFBX = tgaFiles[1]
  )
  else
  (
    print("tgas are empty")
  )

  if pngFiles.count != o then
  (
    realFileFound = false
    position =1
    While not realFileFound do
    (
      flagExclude = false
      for cA in camArray do
      (
        if (pngFils[position] == undeifned) then
        (
          realFileFound = true
          fladExlude = true
        )
        else if (findString pngFiles[position] cA) != undefined do
        (
          flagExclude = true
        )
      )
      if not flagExclude do
      (
        importedFBX = pngFiles[position]
        realFileFound = true
      )
      position = position +1
    )
  )

  if tifFiles.count != 0 then
  (
    importedFBX = tifFiles[1]
  )
  else 
  (
    print("tiffs are empty")
  )

importedTextureMap.Diffusemap = Bitmaptexture filename: importedFBX
pinkMat.Diffuse = (color 255 0 255)
)

fn Combine = --combines the object if it comes in with multiple
(
  sceneObjects = for obj in objects collect obj

  if sceneObjects.count > 0 then
    (
      targetObj = sceneObjects[1]
    )

  if classOf targetObj != Editable_Poly and classOf targetObjects != Editable_mesh then
    (
      converToPoly targetObj
    )
  
  for i =2 to sceneObjects.count do
  (
    currentObject = sceneObjects[i]

      if currentObjecy != targetObj then
    (
      polyop.attach targetObj currentObjetct
    )
  )
)

--reset the scene
  reset_Scene()
----------------------------------------
--sets up the render scene
  global_Renders_Settings()
--------------------------------------

--Directories
rootFOlder = getSavepath Captin: "Choose Folder Location" initialDir:(getDir #scene)

--calls for filetype to look for
global filepattern = "\\*.fbx"

--creats the directory to crrate the loop in
global theFiles = getFiles (rootFolder + filePattern) recurse:true

totalFileCount = theFiles.count

global ProgressCount = 0

for importedFBX in theFiles do
(
  importfile importedFBX #noprompt

  global filePath = getFilenamePath importedFBX

  progressCount += 1

  print("~~~" + importedFBX + ": Started~~~")

  for dummyObj in objects do

)
