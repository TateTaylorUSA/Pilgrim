Scriptname MAG_PrayerSpell_Script extends ActiveMagicEffect  

; This script is from Pray with Amulets by Parapets. The inspiration for Pilgrim's prayer mechanic was essentially "How can I make Pray with Amulets work without amulets?"

Furniture Property PrayerMatBase Auto
Spell Property Blessing Auto
Message Property BlessingMessage Auto

ObjectReference PrayerMatRef

Auto State Start

	Event OnEffectStart(Actor akTarget, Actor akCaster)
		PrayerMatRef = akTarget.PlaceAtMe(PrayerMatBase, abInitiallyDisabled = true)
	
		float fAngle = akCaster.GetAngleZ()
		PrayerMatRef.MoveTo(akCaster, 0, 0, 0)
		PrayerMatRef.SetAngle(0, 0, fAngle)
		PrayerMatRef.Enable()
	
		PrayerMatRef.Activate(akTarget, true)
	EndEvent

	Event OnSit(ObjectReference akFurniture)
		if akFurniture == PrayerMatRef
			GotoState("Praying")
			
			Utility.Wait(0.5)
			Actor kTargetActor = GetTargetActor()
			Blessing.Cast(kTargetActor, kTargetActor)
			if kTargetActor == Game.GetPlayer()
				BlessingMessage.Show()
			endif
		endif
	EndEvent

EndState

State Praying

	Event OnGetUp(ObjectReference akFurniture)
		if akFurniture == PrayerMatRef
			GotoState("Cleanup")
		endif
	EndEvent

	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		PrayerMatRef.Activate(akTarget, true)
		GotoState("Cleanup")
	EndEvent

EndState

State Cleanup

	Event OnBeginState()
		PrayerMatRef.Disable()
		PrayerMatRef.Delete()
	EndEvent

EndState