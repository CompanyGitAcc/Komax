page 50073 "Order Type Location Bin Setup"
{
    PageType = List;
    SourceTable = "Order Type Location Bin Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Default Location Code"; Rec."Default Location Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

