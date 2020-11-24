function dtx_savefigure(fig,fname, varargin)

%save figure in png, pdf or fig format, formats are specified as strings in varargin
%avoir repeat those line many times because I have sometimes lot of
%different figures to save
%create the output folder if it does not exist
%fig is the handler of the figure to save

%default close_fig is false, will become true later if some varargin == 'close'
close_fig = false;

%remove extention on case there is one
[filepath,name] = fileparts(fname);

%remove '..' (and previsous folder in path) from path because it does not work with 'print'
filepath_split              = split(filepath, filesep);
toremove                    = strcmp(filepath_split, '..');
toremove(find(toremove)-1)  = true;
filepath_split              = filepath_split(~toremove);
filepath                    = cell2mat(join(filepath_split,filesep));

%correct output file name
fname = fullfile(filepath,name);

%create output folder if it does not exist
if ~(exist(filepath)==7)
    fprintf('Creating dir %s\n',filepath);
    mkdir(filepath);
end

%do my general settings 
set(fig,'PaperOrientation','landscape');
set(fig,'PaperUnits','normalized');
set(fig,'PaperPosition', [0 0 1 1]);
set(fig,'Renderer','Painters');

%save according to varargin formats
for isave = 1:size(varargin,2)
    switch varargin{isave}
        case 'pdf'
            fprintf('Print figure to %s\n',[fname, '.pdf']);
            print(fig, '-dpdf', fname,'-r600');
        case 'png'
            fprintf('Print figure to %s\n',[fname, '.png']);
            print(fig, '-dpng', fname,'-r600');
        case 'fig'
            fprintf('Save figure to %s\n',[fname, '.fig']);
            savefig(fig,fname);
        case 'close'
            close_fig = true;
        otherwise
            error('%s is not a supported option', varargin{isave});
    end
end

if close_fig
    close(fig);
end