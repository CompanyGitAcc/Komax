pageextension 59064 "TP Posted Return Shpt. Subform" extends "Posted Return Shipment Subform"
{
    layout
    {

        addlast(Control1)
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Unit Of Measure Short Desc."; Rec."Unit Of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
    }
}
