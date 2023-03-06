page 50084 "Product Group Mapping"
{
    PageType = List;
    SourceTable = "Product Group Mapping";

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
        area(creation)
        {
            action("Group Mapping")
            {
                Caption = 'Group Mapping';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GroupMapping: Report "Group Mapping";
                begin
                    GroupMapping.RunModal();
                end;
            }
        }
    }
}

