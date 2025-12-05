import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../AppLocalizations.dart';
import '../ProjectDatabase.dart';
import '../models/Boat.dart';
import '../DAOs/BoatDAO.dart';

/// A stateful page that manages the "Boats for Sale" feature.
///
/// This screen allows:
/// - Listing all boats stored in the local Floor database,
/// - Adding new boats,
/// - Updating existing boats,
/// - Deleting boats,
/// - Loading and saving the last entered boats fields using encrypted shared preferences,
/// - Responsive layout (master–detail on tablet, single page on phone),
/// - Basic localization of labels and messages using [AppLocalizations].
class BoatsForSalePage extends StatefulWidget {
  @override
  State<CarsForSalePage> createState() {
    return CarsForSalePageState();
  }
}

/// State class that contains all UI state, controllers, and database interaction
/// logic for [BoatsForSalePage].
class BoatsForSalePageState extends State<BoatsForSalePage> {
  /// Data Access Object (DAO) used to perform CRUD operations on the Boat table.
  late BoatDAO BoatDAO;

  /// This list is used to build the list view on the left (or full screen on mobile).
  List<Boat> boats = [];

  /// Indicates whether the user is currently in "create new car" mode.
  /// When true in mobile mode, the UI shows the details form instead of the list.
  bool isCreatingNewBoat = false;

  /// Controller for the "Year" text field.
  final TextEditingController yearController = TextEditingController();

  /// Controller for the "Length" text field.
  final TextEditingController lengthController = TextEditingController();

  /// Controller for the "Power Type" text field.
  final TextEditingController powerController = TextEditingController();

  /// Controller for the "Price" text field.
  final TextEditingController priceController = TextEditingController();

  /// Controller for the "Address" text field.
  final TextEditingController addressController = TextEditingController();

  /// Currently selected boat from the list.
  /// - If non-null, the details page is in "edit" mode for this boat.
  /// - If null and [isCreatingNewBoat] is true, the form is used for a new boat.
  Boat? selectedBoat;

  /// Holds the latest form validation error message.
  /// When non-empty, this is rendered as a red error text in the details section.
  String formErrorMessage = "";

  /// Encrypted shared preferences instance used to persist the last entered boat fields.
  ///
  /// This allows the user to reload the last entered values even after app restarts.
  final EncryptedSharedPreferences encPrefs = EncryptedSharedPreferences();

  /// Lifecycle method called when the state is first created.
  /// - Initializes the database using [_initDatabase].
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  /// Lifecycle method called when the state is disposed.
  /// - Disposes all [TextEditingController] instances to free resources.
  @override
  void dispose() {
    yearController.dispose();
    lengthController.dispose();
    powerController.dispose();
    priceController.dispose();
    addressController.dispose();
    super.dispose();
  }

  /// Clears all form text fields and resets the error message.
  void _clearForm() {
    // Reset all controller text values to empty strings.
    yearController.text = "";
    lengthController.text = "";
    powerController.text = "";
    priceController.text = "";
    addressController.text = "";
    // Also clear any previous validation error message.
    formErrorMessage = "";
  }

  /// Saves the current form values to encrypted shared preferences.
  /// This method is typically called after successfully adding or updating a boat.
  Future<void> _saveLastBoatToPrefs() async {
    // Persist each individual field with a dedicated key.
    await encPrefs.setString("last_boat_year", yearController.text);
    await encPrefs.setString("last_boat_length", lengthController.text);
    await encPrefs.setString("last_boat_power", powerController.text);
    await encPrefs.setString("last_boat_price", priceController.text);
    await encPrefs.setString("last_boat_address", addressController.text);
  }

  /// Loads the last saved boat values from encrypted shared preferences into the form fields.
  /// If a value was not saved previously, the corresponding field is set to an empty string.
  Future<void> _loadLastBoatFromPrefs() async {
    // Read previously saved values from encrypted storage.
    final year = await encPrefs.getString("last_boat_year");
    final length = await encPrefs.getString("last_boat_length");
    final power = await encPrefs.getString("last_boat_power");
    final price = await encPrefs.getString("last_boat_price");
    final address = await encPrefs.getString("last_boat_address");

    // Update state so UI reflects loaded values.
    setState(() {
      yearController.text = year ?? "";
      lengthController.text = length ?? "";
      powerController.text = power ?? "";
      priceController.text = price ?? "";
      addressController.text = address ?? "";
      formErrorMessage = "";
    });
  }

  /// Initializes the Floor database and loads all boats into memory.
  /// - Builds the database using [ProjectDatabase].
  /// - Retrieves a [BoatDAO] instance.
  /// - Triggers [_loadBoatsFromDatabase] to populate [boats].
  Future<void> _initDatabase() async {
    // Build or open the Floor database named 'customer_database.db'.
    final db = await $FloorProjectDatabase
        .databaseBuilder('customer_database.db')
        .build();

    // Obtain the BoatDAO implementation generated by Floor.
    BoatDAO = db.boatDAO;
    // Load all existing cars from the database into memory.
    await _loadBoatsFromDatabase();
  }

  /// Loads all boats from the database into the [boats] list and refreshes the UI.
  Future<void> _loadBoatsFromDatabase() async {
    // Retrieve all cars from the DAO.
    final boatList = await BoatDAO.getAllBoats();
    // Update state so the list view rebuilds with the latest data.
    setState(() {
      boats = boatList;
    });
  }

  /// Validates and parses the current form values.
  /// - Validates that all fields are non-empty.
  /// - Ensures:
  ///   - Year is between 1900 and (current year + 1),
  ///   - Price is > 0,
  /// - On failure:
  ///   - Sets [formErrorMessage],
  ///   - Shows a [SnackBar] with the error message,
  ///   - Returns null.
  /// - On success:
  ///   - Clears [formErrorMessage],
  ///   - Returns a [_ParsedBoatForm] with strongly typed values.
  _ParsedBoatForm? _validateAndParseForm(BuildContext context) {
    // Read trimmed values from all controllers.
    final yearText = yearController.text.trim();
    final lengthText = lengthController.text.trim();
    final powerText = powerController.text.trim();
    final priceText = priceController.text.trim();
    final addressText = addressController.text.trim();

    // Check for any empty fields.
    if (yearText.isEmpty ||
        lengthText.isEmpty ||
        powerText.isEmpty ||
        priceText.isEmpty ||
        addressText.isEmpty) {
      // Localized message for empty fields.
      final msg = AppLocalizations.of(context)!.translate("EmptyFieldsBoat")!;
      formErrorMessage = msg;
      // Show feedback to the user via SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return null;
    }

    // Try to parse numeric fields.
    final year = int.tryParse(yearText);
    final length = double.tryParse(lengthText);
    final price = double.tryParse(priceText);

    // Validate year range: must be realistic and not too far in the future.
    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
      final msg = AppLocalizations.of(context)!.translate("InvalidYear")!;
      formErrorMessage = msg;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return null;
    }

    // Validate price as valid.
    if (price == null) {
      final msg = AppLocalizations.of(context)!.translate("InvalidPrice")!;
      formErrorMessage = msg;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return null;
    }

    // Validate kilometers as valid.
    if (length == null) {
      final msg = AppLocalizations.of(context)!.translate("InvalidLength")!;
      formErrorMessage = msg;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return null;
    }

    // Clear previous validation error if everything is valid.
    formErrorMessage = "";

    // Return parsed values wrapped in a helper object.
    return _ParsedCarForm(
      year: yearText,
      length: lengthText,
      power: powerText,
      price: priceText,
      address: addressText,
    );
  }

  /// Handles the creation of a new boat record from the form and persists it.
  ///
  /// Steps:
  /// 1. Validates and parses the form via [_validateAndParseForm].
  /// 2. Creates a new [Boat] instance using the parsed values.
  /// 3. Inserts the car using [boatDAO.insertBoat].
  /// 4. Saves the form fields to encrypted prefs.
  /// 5. Reloads the list of boats from the database.
  /// 6. Resets state flags and clears the form.
  /// 7. Shows a localized "BoatAdded" [SnackBar].
  Future<void> _submitNewBoat(BuildContext context) async {
    // Validate and parse form. Abort if invalid.
    final parsed = _validateAndParseForm(context);
    if (parsed == null) return;

    // Confirm before adding the new car.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.translate("ConfirmAddTitle")!,
        ),
        content: Text(
          AppLocalizations.of(context)!.translate("ConfirmAddMessage")!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.translate("Cancel")!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.translate("Add")!),
          ),
        ],
      ),
    );

    // User canceled or closed the dialog.
    if (confirmed != true) return;

    // Create a new Car instance if user clicked add.
    final newBoat = Boat(
      null,
      parsed.year,
      parsed.length,
      parsed.power,
      parsed.price,
      parsed.address,
    );

    // Persist the new boat in the database.
    await BoatDAO.insertBoat(newBoat);
    // Save the last entered values for possible reuse.
    await _saveLastBoatToPrefs();
    // Reload the full list of boats so the UI shows the new entry.
    await _loadBoatsFromDatabase();

    // Clear the form fields.
    _clearForm();

    // Show success feedback.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate("BoatAdded")!),
      ),
    );
  }

  /// Handles updating the currently selected boat using the form values.
  ///
  /// Steps:
  /// 1. Ensures [selectedBoat] is not null.
  /// 2. Validates and parses the form.
  /// 3. Prompts the user with a confirmation dialog.
  /// 4. Applies the parsed form values to [selectedBoat].
  /// 5. Persists the updated boat using [boatDAO.updateBoat].
  /// 6. Saves the current form values to encrypted preferences.
  /// 7. Reloads the boat list from the database.
  /// 8. Displays a localized "BoatUpdated" SnackBar.
  Future<void> _updateSelectedBoat(BuildContext context) async {
    // If no boat is selected, there is nothing to update.
    if (selectedBoat == null) return;

    // Validate and parse form. Abort if invalid.
    final parsed = _validateAndParseForm(context);
    if (parsed == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.translate("ConfirmUpdateTitle")!,
        ),
        content: Text(
          AppLocalizations.of(context)!.translate("ConfirmUpdateMessage")!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.translate("Cancel")!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.translate("Update")!),
          ),
        ],
      ),
    );

    // User canceled.
    if (confirmed != true) return;

    // Apply the parsed form values to the currently selected car.
    selectedBoat!.year = parsed.year;
    selectedBoat!.length = parsed.length;
    selectedBoat!.power = parsed.power;
    selectedBoat!.price = parsed.price;
    selectedBoat!.address = parsed.address;

    // Persist the updated boat in the database.
    await BoatDAO.updateBoats(selectedBoat!);
    // Save current form values to encrypted prefs.
    await _saveLastBoatToPrefs();
    // Refresh list to reflect the updated boat.
    await _loadBoatsFromDatabase();

    // Show success feedback.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate("CarUpdated")!),
      ),
    );
  }

  /// Handles deletion of the currently selected boat after a confirmation dialog.
  ///
  /// Steps:
  /// 1. Ensures [selectedBoat] is not null.
  /// 2. Displays a localized confirmation dialog.
  /// 3. If the user confirms:
  ///    - Deletes the car using [BaotDAO.deleteBoat].
  ///    - Reloads the car list.
  ///    - Resets [selectedBoat] and [isCreatingNewBoat].
  ///    - Clears the form.
  ///    - Shows a localized "BoatDeleted" [SnackBar].
  Future<void> _deleteSelectedBoat(BuildContext context) async {
    // If no boat is selected, there is nothing to delete.
    if (selectedBoat == null) return;

    // Show a confirmation dialog to avoid accidental deletions.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.translate("DeleteCarConfirmTitle")!,
        ),
        content: Text(
          AppLocalizations.of(context)!.translate("DeleteCarConfirmMessage")!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.translate("No")!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.translate("Yes")!),
          ),
        ],
      ),
    );

    // If user cancels or dismisses dialog, stop here.
    if (confirmed != true) return;

    // Perform the actual delete in the database.
    await BoatDAO.deleteBoat(selectedBoat!);
    // Reload boats from database to remove the deleted entry from the UI.
    await _loadBoatsFromDatabase();

    // Clear any form inputs.
    _clearForm();

    // Show success feedback.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate("BoatDeleted")!),
      ),
    );
  }

  /// Populates the form controllers with the values from the given [boat].
  ///
  /// This is called when the user taps on a car in the list to edit its details.
  void _populateFormFromBoat(Boat boat) {
    setState(() {
      // Copy all fields from the selected car into the text controllers.
      yearController.text = boat.year.toString();
      lengthController.text = boat.length.toString();
      powerController.text = boat.power;
      priceController.text = boat.price.toString();
      addressController.text = boat.address;
      // Clear any previous validation error when switching to a new boat.
      formErrorMessage = "";
    });
  }

  /// Builds the responsive layout for the page.
  ///
  /// - On tablet (wide landscape), shows a master–detail layout:
  ///   - Left side: list of boats,
  ///   - Right side: details or a "Details" hint when nothing is selected.
  /// - On mobile:
  ///   - Shows either the list or the details page, but not both at the same time.
  Widget reactiveLayout() {
    // Obtain screen size to decide between tablet and phone layout.
    final size = MediaQuery.of(context).size;

    // A simple heuristic: if width > height and width > 720, treat as tablet.
    final bool isTablet = size.width > size.height && size.width > 720;

    if (isTablet) {
      // Tablet mode: show list and detail side by side.
      return Row(
        children: [
          // Left pane: list of cars.
          Expanded(flex: 1, child: ListPage()),
          // Right pane: details if creating or editing, else show a placeholder.
          Expanded(
            flex: 2,
            child: (isCreatingNewBoat || selectedBoat != null)
                ? DetailsPage()
                : Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Details")!,
              ),
            ),
          ),
        ],
      );
    }

    // Mobile mode:
    // If the user is creating a new boat or editing one, show the details form.
    if (isCreatingNewBoat || selectedBoat != null) {
      return DetailsPage();
    }

    // Otherwise, show the list view.
    return ListPage();
  }

  /// Builds a styled card representation for a single [car] in the list.
  ///
  /// This method centralizes the visual styling of each list item to keep
  /// the list builder clean.
  Widget _styledListCard(Boat boat) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "${boat.id}: ${boat.year} ${boat.length} ${boat.power}",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),

          Text(
            "${AppLocalizations.of(context)!.translate("Price")!}: \$${boat.price} • "
                "${AppLocalizations.of(context)!.translate("Address")!}: ${boat.address}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  /// Builds a styled text field with a white card-like background and shadow.
  ///
  /// Parameters:
  /// - [controller]: The [TextEditingController] managing the text.
  /// - [label]: Localized label to display in the input decoration.
  /// - [keyboardType]: Type of keyboard to show (defaults to text).
  ///
  /// If [keyboardType] is numeric, an input formatter is applied to restrict
  /// the input to digits and periods.
  Widget _styledTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        // Restrict input if numeric keyboard is requested.
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
            : null,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Builds the "list" page that shows all boats and an "Add New Boat" button.
  /// On tablet, this is the left pane. On mobile, this takes the full screen
  /// when not in details mode.
  Widget ListPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Button to start creating a new car.
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Clear the current selection and enter creation mode.
                selectedBoat = null;
                isCreatingNewBoat = true;
                _clearForm();
              });
            },
            child: Text(AppLocalizations.of(context)!.translate("AddNewBoat")!),
          ),
          const SizedBox(height: 10),
          // If there are no boats, show a friendly message. Otherwise, show the list.
          boats.isEmpty
              ? Text(
            AppLocalizations.of(context)!.translate("NoBoats")!,
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: boats.length,
              itemBuilder: (context, index) {
                final boat = boats[index];
                return GestureDetector(
                  // When a boat is tapped, populate the form and switch to edit mode.
                  onTap: () {
                    _populateFormFromBoat(boat);
                    setState(() {
                      selectedBoat = boat;
                      isCreatingNewBoat = false;
                    });
                  },
                  child: _styledListCard(boat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the details page that contains the form for adding or editing a boat.
  ///
  /// - Contains:
  ///   - "Load Last Boat" button,
  ///   - Dynamic title ("Details" or "Add New Boat"),
  ///   - Styled text fields,
  ///   - Validation error messages,
  ///   - Action buttons:
  ///     - Add, Update, Remove, Reset, Close.
  Widget DetailsPage() {
    // Determine whether we are editing an existing boat or creating a new one.
    bool editing;
    if (selectedBoat != null) {
      // A boat has been selected from the list, so the form is in "edit" mode.
      editing = true;
    } else {
      // No boat is selected, so the form is in "add new boat" mode.
      editing = false;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Button to load the last saved boat from encrypted prefs.
            ElevatedButton(
              onPressed: _loadLastBoatFromPrefs,
              child: Text(
                AppLocalizations.of(context)!.translate("LoadLastBoat")!,
              ),
            ),
            const SizedBox(height: 16),

            // Title changes depending on whether we are editing or adding.
            Text(
              editing
                  ? AppLocalizations.of(context)!.translate("Details")!
                  : AppLocalizations.of(context)!.translate("AddNewBoat")!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Year field.
            _styledTextField(
              controller: yearController,
              label: AppLocalizations.of(context)!.translate("Year")!,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Make field.
            _styledTextField(
              controller: lengthController,
              label: AppLocalizations.of(context)!.translate("Length")!,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Model field.
            _styledTextField(
              controller: powerController,
              label: AppLocalizations.of(context)!.translate("Power")!,
            ),
            const SizedBox(height: 12),

            // Price field.
            _styledTextField(
              controller: priceController,
              label: AppLocalizations.of(context)!.translate("Price")!,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Kilometers field.
            _styledTextField(
              controller: addressController,
              label: AppLocalizations.of(context)!.translate("Address")!,
            ),

            const SizedBox(height: 20),

            // If there is a validation error message, show it.
            if (formErrorMessage.isNotEmpty)
              Text(formErrorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),

            // Group of action buttons: Add/Update/Remove/Reset/Close.
            Wrap(
              spacing: 12,
              children: [
                // Add button (only visible when not editing an existing boat).
                if (!editing)
                  ElevatedButton(
                    onPressed: () => _submitNewBoat(context),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Add")!,
                    ),
                  ),
                // Update button (only visible if a boat is selected).
                if (editing)
                  ElevatedButton(
                    onPressed: () => _updateSelectedBoat(context),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Update")!,
                    ),
                  ),
                // Remove button (only visible if a boat is selected).
                if (editing)
                  ElevatedButton(
                    onPressed: () => _deleteSelectedBoat(context),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Remove")!,
                    ),
                  ),
                // Reset button to clear all form fields.
                ElevatedButton(
                  onPressed: _clearForm,
                  child: Text(
                    AppLocalizations.of(context)!.translate("ResetBoatFields")!,
                  ),
                ),
                // Close button: exits details mode and returns to the list (on mobile),
                // or simply clears selection in tablet layout.
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedBoat = null;
                      isCreatingNewBoat = false;
                      _clearForm();
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate("Close")!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the top-level [Scaffold] for the page, including:
  /// - App bar with title, instructions button, and language toggle buttons,
  /// - Body that is rendered by [reactiveLayout].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Localized page title.
        title: Text(AppLocalizations.of(context)!.translate("BoatListTitle")!),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Instructions button: opens a dialog with localized instructions.
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      AppLocalizations.of(
                        context,
                      )!.translate("BoatInstructionsTitle")!,
                    ),
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.translate("BoatInstructions")!,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context)!.translate("Close")!,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate("BoatInstructionsTitle")!,
            ),
          ),
          // English locale switch.
          FilledButton(
            onPressed: () {
              MyApp.setLocale(context, const Locale("en"));
            },
            child: Text(AppLocalizations.of(context)!.translate("English")!),
          ),
        ],
      ),
      // Main body uses a responsive layout.
      body: reactiveLayout(),
    );
  }
}

/// Helper data class that stores parsed form values for a boat.
///
/// This is used as a return type of [_validateAndParseForm] to keep
/// parsing and validation separate from the entity model [Boat].
class _ParsedBoatForm {
  /// Parsed year of manufacture.
  final int year;

  /// Parsed make (manufacturer) of the boat.
  final double length;

  /// Parsed power of the boat.
  final String power;

  /// Parsed price of the boat.
  final double price;

  /// Parsed address.
  final String address;

  /// Creates a new [_ParsedCarForm] with all required fields.
  _ParsedCarForm({
    required this.year,
    required this.length,
    required this.power,
    required this.price,
    required this.address,
  });
}