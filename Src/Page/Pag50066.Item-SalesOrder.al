page 50066 "Way Of Dispatch"
{
    PageType = List;
    SourceTable = "Way Of Dispatch";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("Dispatch Time"; Rec."Dispatch Time")
                {
                    ApplicationArea = all;
                }
            }
        }
    }




}

