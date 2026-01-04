#include "my_application.h"
#include <locale.h>

int main(int argc, char** argv) {
  // Set C locale for numeric formatting (required by media_kit)
  setlocale(LC_NUMERIC, "C");
  
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
