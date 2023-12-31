program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.JSON,
  Horse.Commons,
  Horse.Jhonson,
  System.Classes,
  System.SysUtils;

var
  App: THorse;
  Users: TJSONArray;

begin

  App := THorse.Create;

  App.Use(Jhonson);

  Users := TJSONArray.Create;

  App.Get('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send<TJSONAncestor>(Users.Clone).Status(THTTPStatus.OK);
    end);

  App.Post('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      User: TJSONObject;
    begin
      User := Req.Body<TJSONObject>.Clone as TJSONObject;
      Users.AddElement(User);
      Res.Send<TJSONAncestor>(User.Clone).Status(THTTPStatus.Created);
    end);

  App.Delete('/users/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      id: Integer;
    begin
      id := Req.Params.Items['id'].ToInteger;
      //Users.Remove(id  -1).Free;
      Users.Remove(Pred(id)).Free;
      Res.Send<TJSONAncestor>(Users.Clone).Status(THTTPStatus.NoContent);
    end);

  App.Listen(4000);

end.

