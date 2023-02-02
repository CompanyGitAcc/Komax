page 50038 "Machine Model"
{
    Caption = 'Machine Model';
    // Editable = false;
    // InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Machine Model";
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }

            }



        }
    }

    actions
    {

    }


}


