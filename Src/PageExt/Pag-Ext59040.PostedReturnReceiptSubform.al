pageextension 59040 "TP Posted Return Rec. Subform" extends "Posted Return Receipt Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }
        }
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
