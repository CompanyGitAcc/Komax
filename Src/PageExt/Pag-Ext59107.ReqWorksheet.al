pageextension 59107 "TP Req. Worksheet" extends "Req. Worksheet"
{
    layout
    {
        modify("ShortcutDimCode[3]")
        {
            Visible = true;
        }
        modify("ShortcutDimCode[4]")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
        }
        modify("Requester ID")
        {
            Visible = true;
        }
    }



}
