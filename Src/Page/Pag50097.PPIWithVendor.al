page 50097 "PPI With Vendor"
{

    Caption = 'PPI With Vendor';
    PageType = List;
    SourceTable = "PPI With Vendor";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field(Currency; Rec.Currency)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }

            }
        }
    }

    actions
    {
    }
}