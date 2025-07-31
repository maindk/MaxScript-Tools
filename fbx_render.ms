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
