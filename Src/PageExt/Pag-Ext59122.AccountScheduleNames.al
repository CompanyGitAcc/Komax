pageextension 59122 "TP Account Schedule Names" extends "Account Schedule Names"
{
    layout
    {
        addlast(Control1)
        {
            field("Left Starting Line"; Rec."Left Starting Line")
            {
                ApplicationArea = all;
            }
            field("Left Ending Line"; Rec."Left Ending Line")
            {
                ApplicationArea = all;
            }
            field("Right Starting Line"; Rec."Right Starting Line")
            {
                ApplicationArea = all;
            }
            field("Right Ending Line"; Rec."Right Ending Line")
            {
                ApplicationArea = all;
            }
            field("Report ID"; Rec."Report ID")
            {
                ApplicationArea = all;
            }
        }
    }

}
