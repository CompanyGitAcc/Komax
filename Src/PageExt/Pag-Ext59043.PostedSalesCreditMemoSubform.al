pageextension 59043 "TP Pst. Sales Cr. Memo Subform" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {

        addbefore(Quantity)
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }

    }

}
