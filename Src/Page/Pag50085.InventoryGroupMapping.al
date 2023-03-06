page 50085 "Inventory Group Mapping"
{
    PageType = List;
    SourceTable = "Inventory Group Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("New Code"; Rec."New Code")
                {
                }
                field(Number; Rec.Number)
                {
                }
            }
        }
    }

    actions
    {
    }
}

