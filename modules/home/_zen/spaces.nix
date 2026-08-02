{ containers, ... }:{
  "Personal" = {
    id = "4d929899-3c7c-44e3-be00-e1e850836b6f";
    icon = "chrome://browser/skin/zen-icons/selectable/people.svg";
    position = 1000;
    # container = containers."Personal".id;
    theme = {
      type = "gradient";
      colors = [{
        algorithm = "floating";
        type = "explicit-lightness";
        red = 107;
        green = 126;
        blue = 148;
        lightness = 50;
        position = { x = 51; y = 97; };
      }];
      opacity = 0.5;
    };
  };

  "NJIT" = {
    id = "b3e1a2f4-9c8d-4e7a-b5f0-2d6c3a1e8b9f";
    icon = "chrome://browser/skin/zen-icons/selectable/school.svg";
    position = 2000;
    # container = containers."School".id;
    theme = {
      type = "gradient";
      colors = [{
        algorithm = "floating";
        type = "explicit-lightness";
        red = 190;
        green = 20;
        blue = 30;
        lightness = 50;
        position = { x = 50; y = 100; };
      }];
      opacity = 0.5;
    };
  };

  "Research" = {
    id = "c7f2b3e5-1d4a-4f8b-a6c9-3e7d5b2a9c1e";
    icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
    position = 3000;
    # container = containers."School".id;
    theme = {
      type = "gradient";
      colors = [{
        algorithm = "floating";
        type = "explicit-lightness";
        red = 30;
        green = 150;
        blue = 130;
        lightness = 50;
        position = { x = 50; y = 100; };
      }];
      opacity = 0.5;
    };
  };
}
