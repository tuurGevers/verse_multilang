
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Main := class(creative_device):
    @editable Buttons: []InteractableButton = array{}
    @editable Billboards: []InteractableBillboard = array{}
    @editable HudMessages: []InteractableHudMessage = array{}
    @editable ConditionalButtons: []InteractableConditionalButton = array{}

    @editable BE_Button: button_device = button_device{}
    @editable EN_Button: button_device = button_device{}
    @editable FR_Button: button_device = button_device{}
    @editable DE_Button: button_device = button_device{}
    @editable ES_Button: button_device = button_device{}

    var CurrentLang:LangCode=LangCode.EN
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        BE_Button.InteractedWithEvent.Subscribe(LangChanger{MainDevice:=Self, SelectedLang:=LangCode.BE}.Handler)
        EN_Button.InteractedWithEvent.Subscribe(LangChanger{MainDevice:=Self, SelectedLang:=LangCode.EN}.Handler)
        FR_Button.InteractedWithEvent.Subscribe(LangChanger{MainDevice:=Self, SelectedLang:=LangCode.FR}.Handler)
        DE_Button.InteractedWithEvent.Subscribe(LangChanger{MainDevice:=Self, SelectedLang:=LangCode.DE}.Handler)
        ES_Button.InteractedWithEvent.Subscribe(LangChanger{MainDevice:=Self, SelectedLang:=LangCode.ES}.Handler)

        UpdateAll()
        
    UpdateAll():void=
        for(Button : Buttons):
            Button.UpdateLang(CurrentLang)
        for(Billboard : Billboards):
            Billboard.UpdateLang(CurrentLang)
        for(HudMessage : HudMessages):
            HudMessage.UpdateLang(CurrentLang)
        for(ConditionalButton : ConditionalButtons):
            ConditionalButton.UpdateLang(CurrentLang)
#LangChanger class
LangChanger:=class:
    MainDevice:Main
    SelectedLang:LangCode

    Handler(Player:agent):void=
        set MainDevice.CurrentLang=SelectedLang
        MainDevice.UpdateAll()

#different langs
LangCode:= enum:
    BE
    EN
    FR
    DE
    ES

#Interactable devices
InteractableButton:= class<concrete>(Interactable):
    @editable Button:button_device=button_device{}

    UpdateLang(Code:LangCode):void=
        Print("updating lang")
        Button.SetInteractionText(GetMessage(Code))

InteractableConditionalButton:= class<concrete>(Interactable):
    @editable Button:conditional_button_device=conditional_button_device{}

    UpdateLang(Code:LangCode):void=
        Print("updating lang")
        Button.SetInteractionText(GetMessage(Code))
       
InteractableBillboard:= class<concrete>(Interactable):
    @editable Billboard:billboard_device=billboard_device{}

    UpdateLang(Code:LangCode):void=
        Print("updating lang")
        Billboard.SetText(GetMessage(Code))

InteractableHudMessage:= class<concrete>(Interactable):
    @editable HudMessage:hud_message_device=hud_message_device{}

    UpdateLang(Code:LangCode):void=
        Print("updating lang")
        HudMessage.SetText(GetMessage(Code))

Interactable:= class<concrete>:
    @editable BE_Text:string="aanraken"
    @editable EN_Text:string="touch"
    @editable FR_Text:string="toucher"
    @editable DE_Text:string="berühren"
    @editable ES_Text:string="tocar"
    SetText<localizes><public>(Message:string)<transacts>: message = "{Message}"

    #Get message based on lang
    GetMessage(Code:LangCode):message=
        case(Code):
            LangCode.BE=>return SetText("{BE_Text}")
            LangCode.EN=>return SetText("{EN_Text}")
            LangCode.FR=>return SetText("{FR_Text}")
            LangCode.DE=>return SetText("{DE_Text}")
            LangCode.ES=>return SetText("{ES_Text}")
            