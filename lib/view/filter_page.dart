import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/filter_cubit.dart';
import 'result_page.dart';

class FilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Diamonds'),
      ),
      body: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Carat Range',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text("Min: ${state.caratFrom.toStringAsFixed(2)}"),
                Slider(
                  min: 0.5,
                  max: state.caratTo, // Ensuring min < max
                  value: state.caratFrom,
                  divisions: 45,
                  onChanged: (newMin) {
                    context
                        .read<FilterCubit>()
                        .updateFilters(caratFrom: newMin);
                  },
                ),
                Text("Max: ${state.caratTo.toStringAsFixed(2)}"),
                Slider(
                  min: state.caratFrom, // Ensuring min < max
                  max: 5.0,
                  value: state.caratTo,
                  divisions: 45,
                  onChanged: (newMax) {
                    context.read<FilterCubit>().updateFilters(caratTo: newMax);
                  },
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  'Lab',
                  state.lab,
                  ['GIA', 'IGI', 'HRD'],
                  (value) =>
                      context.read<FilterCubit>().updateFilters(lab: value),
                ),
                _buildDropdown(
                  'Shape',
                  state.shape,
                  ['Round', 'Princess', 'Oval'],
                  (value) =>
                      context.read<FilterCubit>().updateFilters(shape: value),
                ),
                _buildDropdown(
                  'Color',
                  state.color,
                  ['D', 'E', 'F', 'G'],
                  (value) =>
                      context.read<FilterCubit>().updateFilters(color: value),
                ),
                _buildDropdown(
                  'Clarity',
                  state.clarity,
                  ['IF', 'VVS1', 'VVS2'],
                  (value) =>
                      context.read<FilterCubit>().updateFilters(clarity: value),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    child: Text('Search'),
                    onPressed: () {
                      context.read<FilterCubit>().fetchDiamonds();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String title, String selectedValue,
      List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ToggleButtons(
          isSelected: options.map((e) => e == selectedValue).toList(),
          onPressed: (index) => onChanged(options[index]),
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          color: Colors.black,
          children: options
              .map((option) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(option),
                  ))
              .toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
