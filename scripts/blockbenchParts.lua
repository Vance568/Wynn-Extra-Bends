PModel = models.model.Player
ModelHead = PModel.Upper.head
ModelMainBody = PModel.Upper
ModelRightArm = PModel.Upper.body.Arms.Arm_R
ModelLeftArm = PModel.Upper.body.Arms.Arm_L
ModelRightLeg = PModel.Lower.Leg_R
ModelLeftLeg = PModel.Lower.Leg_L
ModelCape = PModel.Upper.body.Cape

ModelJacket = ModelMainBody.body.Body_Overlay
ModelHat = ModelHead.Head_Overlay

ModelRightArmDefaultSleeveUpper = ModelRightArm.Bicep_Default_R.Bicep_Overlay_R
ModelRightArmDefaultSleeveLower = ModelRightArm.Elbow_R.Limb_Default_R.Limb_Overlay_R
ModelRightArmSlimSleeveUpper = ModelRightArm.Bicep_Slim_R.Bicep_Overlay_R
ModelRightArmSlimSleeveLower = ModelRightArm.Elbow_R.Limb_Slim_R.Limb_Overlay_R

ModelLeftArmDefaultSleeveUpper = ModelLeftArm.Bicep_Default_L.Bicep_Overlay_L
ModelLeftArmDefaultSleeveLower = ModelLeftArm.Elbow_L.Limb_Default_L.Limb_Overlay_L
ModelLeftArmSlimSleeveUpper = ModelLeftArm.Bicep_Slim_L.Bicep_Overlay_L
ModelLeftArmSlimSleeveLower = ModelLeftArm.Elbow_L.Limb_Slim_L.Limb_Overlay_L

ModelRightLegPantUpper = ModelRightLeg.Thigh_Overlay_R
ModelRightLegPantLower = ModelRightLeg.Knee_R.Foot_Overlay_R
ModelLeftLegPantUpper = ModelLeftLeg.Thigh_Overlay_L
ModelLeftLegPantLower = ModelLeftLeg.Knee_L.Foot_Overlay_L