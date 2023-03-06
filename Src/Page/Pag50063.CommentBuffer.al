page 50063 "Comment Buffer"
{
    PageType = List;
    SourceTable = "Comment Line Buffer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Name"; Rec."Table Name")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Code; Rec.Code)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field(Warning; Rec.Warning)
                {
                }
            }
        }
    }

    actions
    {
    }
}

