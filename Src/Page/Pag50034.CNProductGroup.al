page 50034 "TP Product Group"
{
    Caption = 'CN Product Group';
    PageType = List;
    SourceTable = "TP Product Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
