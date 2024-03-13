import 'package:budget_basket/util/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    Key? key,
    this.isChecked = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with SingleTickerProviderStateMixin {
  late bool _isChecked;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    if (_isChecked) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    if (widget.onChanged != null) {
      widget.onChanged!(_isChecked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 28.0, // You can adjust the size
        width: 28.0, // You can adjust the size
        decoration: BoxDecoration(
          color: _isChecked
              ? MyColors.blue
              : Colors.transparent, // Change as needed
          border: Border.all(
            color: MyColors.blue, // Change as needed
            width: 3,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _isChecked
              ? Icon(
                  PhosphorIcons.check(PhosphorIconsStyle.bold),
                  key: ValueKey<bool>(_isChecked),
                  size: 20.0,
                  color: Colors.white, // Change as needed
                )
              : Container(
                  key: ValueKey<bool>(_isChecked),
                ), // Empty container for unchecked state
        ),
      ),
    );
  }
}
