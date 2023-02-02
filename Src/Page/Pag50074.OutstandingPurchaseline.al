page 50074 "Outstanding Purchase line"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order | "Return Order"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }
}

