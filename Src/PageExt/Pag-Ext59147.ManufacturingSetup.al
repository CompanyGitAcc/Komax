pageextension 59147 "TP Manufacturing Setup" extends "Manufacturing Setup"
{
    layout
    {
        addlast(General)
        {
            field("Production Location"; Rec."Production Location")
            {
                ApplicationArea = all;
            }
            field("Default Movement Worksheet"; Rec."Default Movement Worksheet")
            {
                ApplicationArea = all;
            }
        }
    }



}
