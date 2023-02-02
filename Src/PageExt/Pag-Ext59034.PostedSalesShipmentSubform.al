pageextension 59034 "TP Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        modify("Item Reference No.")
        {
            Visible = true;
        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
        }

    }



}
