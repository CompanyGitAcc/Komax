pageextension 59067 "TP Ps. Purch. Cr. Memo Subform" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        //++YK004-HH220101
        addbefore(Quantity)
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("No.")
        {

        }
        //--YK004
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
        }
    }
}
